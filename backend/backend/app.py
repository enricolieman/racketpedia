from flask import Flask, request, jsonify
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import euclidean_distances, cosine_similarity
from sklearn.preprocessing import MinMaxScaler

app = Flask(__name__)

# Load data and preprocess
data = pd.read_csv('Dataset_Raket2.csv', encoding='ISO-8859-1')
original_data = data.copy()


# Mapping for categorical values
stiffness_mapping = {'Stiff': 0.0, 'Medium': 0.5, 'Flex': 1.0}
data['Stiffness'] = data['Stiffness'].map(stiffness_mapping)

balance_point_mapping = {'Head Heavy': 0.0, 'Even Balance': 0.5, 'Head Light': 1.0}
data['Balance_Point'] = data['Balance_Point'].map(balance_point_mapping)

# Normalize numerical features
scaler = MinMaxScaler()
data[['Price', 'Weight']] = scaler.fit_transform(data[['Price', 'Weight']])

# TF-IDF Vectorization with lowercasing
tfidf_vectorizer = TfidfVectorizer(lowercase=True, stop_words='english')
data['Description'] = data['Description'].fillna('').str.lower()
tfidf_matrix = tfidf_vectorizer.fit_transform(data['Description'])

@app.route('/recommend', methods=['POST'])
def recommend_racket():
    user_data = request.get_json()
    user_price = user_data['price']
    user_weight = user_data['weight']
    user_stiffness = user_data['stiffness']
    user_balance_point = user_data['balance_point']
    user_brand = user_data.get('brand', '').strip()
    user_keyword = user_data.get('keyword', '').strip().lower()  # Ensure keyword is lowercase

    print(f"User Keyword: '{user_keyword}'")  # Debug: Check keyword

    # Check if stiffness is set to 'Random', otherwise map it
    if user_stiffness == 'Random':
        user_stiffness_value = random.choice([0.0, 0.5, 1.0])
    else:
        user_stiffness_value = stiffness_mapping.get(user_stiffness, 0)

    # Check if balance point is set to 'Random', otherwise map it
    if user_balance_point == 'Random':
        user_balance_point_value = random.choice([0.0, 0.5, 1.0])
    else:
        user_balance_point_value = balance_point_mapping.get(user_balance_point, 0)

    # Scale numerical features for user input
    user_price_weight_scaled = scaler.transform(pd.DataFrame([[user_price, user_weight]], columns=['Price', 'Weight']))

    # Filter data based on selected brand
    if user_brand != 'Random':
        filtered_data = data[data['Brand'].str.lower() == user_brand.lower()]
        if filtered_data.empty:
            return jsonify({"status": "error", "message": "No data available for the selected brand"}), 400
    else:
        filtered_data = data

    # Prepare features for Euclidean distance computation
    filtered_numerical_features = filtered_data[['Price', 'Weight', 'Stiffness', 'Balance_Point']].values
    user_numerical_vector = np.hstack((user_price_weight_scaled.flatten(), 
                                       [user_stiffness_value, user_balance_point_value]))

    # Calculate Euclidean distance
    distances = euclidean_distances(user_numerical_vector.reshape(1, -1), filtered_numerical_features)

    # Calculate cosine similarity based on user keyword
    if user_keyword:
        user_keyword_tfidf = tfidf_vectorizer.transform([user_keyword])
        print(f"User Keyword TF-IDF: {user_keyword_tfidf}")  # Debug: Check TF-IDF

        if user_keyword_tfidf.nnz == 0:
            cosine_similarities = np.zeros((1, len(filtered_data)))
        else:
            cosine_similarities = cosine_similarity(user_keyword_tfidf, tfidf_matrix[filtered_data.index])
    else:
        cosine_similarities = np.zeros((1, len(filtered_data)))

    # Combine results
    weight_cosine = 0.7  # Adjust this value based on importance
    combined_scores = distances[0] - weight_cosine * cosine_similarities.flatten()

    # Get top N recommendations
    indices = np.argsort(combined_scores)[:10]
    recommendations = original_data.iloc[filtered_data.index[indices]][['Brand', 'Model', 'Price', 'Weight', 'Stiffness', 'Balance_Point', 'Image', 'Description']]
    
    # Print distances and cosine similarities
    for i in indices:
        print(f"Distance to {original_data.iloc[filtered_data.index[i]]['Brand']} - {original_data.iloc[filtered_data.index[i]]['Model']}: {distances[0][i]:.4f}, Cosine Similarity: {cosine_similarities[0][i]:.4f}")

    # Return recommendations
    return jsonify({
        "status": "success",
        "recommendations": recommendations.to_dict(orient='records')
    }), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

from flask import Flask, request, jsonify
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import euclidean_distances, cosine_similarity
from sklearn.preprocessing import MinMaxScaler
from flask_cors import CORS
import warnings
import logging
import nltk
from nltk.tokenize import word_tokenize
from Sastrawi.Stemmer.StemmerFactory import StemmerFactory
from supabase import create_client

# Suppress warnings
warnings.filterwarnings("ignore", category=UserWarning)

# Set up logging
logging.basicConfig(level=logging.INFO)

# Download NLTK resources
nltk.download('punkt')

app = Flask(__name__)
CORS(app)

# # Load data 
# data = pd.read_csv('Dataset_Raket2.csv', encoding='ISO-8859-1')
# original_data = data.copy()

# URL dan API key Supabase
url = "https://nmawtbiigrkveeovsctu.supabase.co"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5tYXd0YmlpZ3JrdmVlb3ZzY3R1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1ODAwMzAsImV4cCI6MjA0NzE1NjAzMH0.PN20e0p-VEIGvUgK7MZkVZGDDwl3YWDufv-KE8cxVxI"  
supabase = create_client(url, key)

# Get data from Supabase
def fetch_data_from_supabase():
    response = supabase.table('Rackets_data1').select('*').execute()
    if response.data:
        return pd.DataFrame(response.data)
    else:
        raise Exception("No data found in Supabase.")

try:
    data = fetch_data_from_supabase()
    original_data = data.copy()
except Exception as e:
    logging.error(f"Error loading data from Supabase: {str(e)}")
    data = pd.DataFrame()  # Empty dataframe in case of error

# Mapping for categorical values
stiffness_mapping = {'Stiff': 0.0, 'Medium': 0.5, 'Flex': 1.0}
balance_point_mapping = {'Head Heavy': 0.0, 'Even Balance': 0.5, 'Head Light': 1.0}
data['Stiffness'] = data['Stiffness'].map(stiffness_mapping)
data['Balance_Point'] = data['Balance_Point'].map(balance_point_mapping)

# Normalize numerical features
scaler = MinMaxScaler()
data[['Price', 'Weight']] = scaler.fit_transform(data[['Price', 'Weight']])

# Initialize the Indonesian Sastrawi Stemmer
factory = StemmerFactory()
stemmer = factory.create_stemmer()

custom_stopwords = [
    "menghasilkan", "untuk", "dengan", "lebih", "antara", 
    "yang", "ini", "dan", "tersebut", "adalah", "memiliki", 
    "anda", "merupakan", "memberikan", "memungkinkan", "itu", 
    "hasil", "digunakan", "sangat", "selain", "seperti", 
    "sehingga", "pada", "dari", "di", "rangka", "shuttlecock", 
    "pemain", "lapangan", "tingkat", "baik", "tinggi", "juga", 
    "oleh", "maka", "bahwa", "raket", "bulutangkis", "badminton",
    "teknologi", "permainan", "meningkatkan", "pukulan", 
    "akurat", "berbagai", "penanganan", "performa", "kritis", 
    "situasi", "membuat", "racket", "bagi"
]

# Preprocess text
def preprocess_text(text):
    tokens = word_tokenize(text)
    tokens = [
        stemmer.stem(token.lower())
        for token in tokens
        if token.lower() not in custom_stopwords and token.isalpha() or token.isdigit()
    ]
    return ' '.join(tokens)

data['Processed_Description'] = data['Description'].apply(preprocess_text)  

# TF-IDF Vectorization with custom max_df and min_df
tfidf_vectorizer = TfidfVectorizer(ngram_range=(1, 3), max_df=0.8, min_df=2)  
tfidf_matrix = tfidf_vectorizer.fit_transform(data['Processed_Description'])  


@app.route('/')
def index():
    return "Hello, World!"

@app.route('/rackets', methods=['GET'])
def get_rackets():
    try:
        rackets_data = original_data[['Brand', 'Model', 'Price', 'Weight', 'Stiffness', 'Balance_Point', 'Image', 'Description']]
        return jsonify({"status": "success", "rackets": rackets_data.to_dict(orient='records')}), 200
    except Exception as e:
        logging.error("Error retrieving rackets: %s", str(e))
        return jsonify({"status": "error", "message": "Error retrieving rackets."}), 500

@app.route('/recommend', methods=['POST'])
def recommend_racket():
    user_data = request.get_json()

    # Validate user data
    if user_data is None or not isinstance(user_data, dict):
        return jsonify({"status": "error", "message": "No valid input data provided."}), 400

    # Retrieve and validate user inputs
    user_price = user_data.get('price')
    user_weight = user_data.get('weight')
    user_stiffness = user_data.get('stiffness')
    user_balance_point = user_data.get('balance_point')
    user_brand = user_data.get('brand', 'Random') if isinstance(user_data.get('brand'), str) else 'Random'
    user_keyword = user_data.get('keyword', '').strip().lower()

    # Treat "Random" as None for stiffness and balance point
    user_stiffness = None if user_stiffness == 'Random' else user_stiffness
    user_balance_point = None if user_balance_point == 'Random' else user_balance_point

    print("Processed Inputs:")
    print("Price:", user_price)
    print("Weight:", user_weight)
    print("Stiffness:", user_stiffness)
    print("Balance Point:", user_balance_point)
    print("Brand:", user_brand)
    print("Keyword:", user_keyword)

    # Normalize user inputs if available
    try:
        user_price_value = scaler.transform([[user_price, 0]])[0][0] if user_price is not None else None
        user_weight_value = scaler.transform([[0, user_weight]])[0][1] if user_weight is not None else None
        user_stiffness_value = stiffness_mapping.get(user_stiffness) if user_stiffness is not None else None
        user_balance_point_value = balance_point_mapping.get(user_balance_point) if user_balance_point is not None else None
    except Exception as e:
        return jsonify({"status": "error", "message": "Invalid numerical input."}), 400

    # Filter data based on the selected brand
    filtered_data = data if user_brand == 'Random' else data[data['Brand'] == user_brand]
    
    # Initialize recommendations
    recommendations = pd.DataFrame()

    # === Euclidean Distance Calculation ===
    if any([user_price is not None, user_weight is not None, user_stiffness is not None, user_balance_point is not None]):
        user_numerical_vector = [v for v in [user_price_value, user_weight_value, user_stiffness_value, user_balance_point_value] if v is not None]
        filled_indices = [i for i, v in enumerate([user_price_value, user_weight_value, user_stiffness_value, user_balance_point_value]) if v is not None]

        if filled_indices:
            relevant_features = filtered_data[['Price', 'Weight', 'Stiffness', 'Balance_Point']].values[:, filled_indices]
            user_vector = np.array(user_numerical_vector).reshape(1, -1)
            if relevant_features.shape[0] > 0 and user_vector.shape[1] == relevant_features.shape[1]:
                distances = euclidean_distances(user_vector, relevant_features)
                sorted_indices = np.argsort(distances.flatten())[:10]
                recommendations = original_data.iloc[filtered_data.index[sorted_indices]][['Brand', 'Model', 'Price', 'Weight', 'Stiffness', 'Balance_Point', 
                'Image', 'Description']]

            print("\n=== Euclidean Distance Results ===")
            for i in sorted_indices:
                brand_model = f"{original_data.iloc[filtered_data.index[i]]['Brand']} {original_data.iloc[filtered_data.index[i]]['Model']}"
                print(f"{brand_model.ljust(40)} {distances.flatten()[i]:.4f}")

    # === Cosine Similarity Calculation ===
    if user_keyword:
        user_keyword = preprocess_text(user_keyword)
        user_keyword_tfidf = tfidf_vectorizer.transform([user_keyword])
        
        # Check if there is a valid tf-idf representation for the keyword
        if user_keyword_tfidf.nnz > 0:
            weighted_user_keyword_tfidf = 2 * user_keyword_tfidf 
            cosine_similarities = cosine_similarity(user_keyword_tfidf, tfidf_matrix[filtered_data.index])
            # Ensure sorted_indices only exists if there are valid similarities
            if cosine_similarities.size > 0:
                sorted_indices = np.argsort(-cosine_similarities.flatten())[:10]
                recommendations = original_data.iloc[filtered_data.index[sorted_indices]][
                    ['Brand', 'Model', 'Price', 'Weight', 'Stiffness', 'Balance_Point', 'Image', 'Description']
                ]
                
                print("\n=== Cosine Similarity Results ===")
                for i in sorted_indices:
                    brand_model = f"{original_data.iloc[filtered_data.index[i]]['Brand']} {original_data.iloc[filtered_data.index[i]]['Model']}"
                    print(f"{brand_model.ljust(40)} {cosine_similarities.flatten()[i]:.4f}")

    # === Combined Euclidean and Cosine Similarity Calculation ===
    if any([user_price is not None, user_weight is not None, user_stiffness is not None, user_balance_point is not None]) and user_keyword:
        # Run the combined score calculation only if there are both keyword and numerical features provided
        combined_scores = np.full(len(filtered_data), np.inf)
        euclidean_similarity = 1 / (1 + distances.flatten()) if 'distances' in locals() else np.zeros(len(filtered_data))
        cosine_similarities_flat = 2 * cosine_similarities.flatten() if 'cosine_similarities' in locals() else np.zeros(len(filtered_data))
        cosine_similarities_flat[cosine_similarities_flat == 0] = 0.1  # Prevent zero values if necessary

        # Combined score calculation
        combined_scores = euclidean_similarity * 0.5 + cosine_similarities_flat * 0.5
        combined_scores = np.nan_to_num(combined_scores)
        sorted_indices = np.argsort(combined_scores)[::-1][:10]
        recommendations = original_data.iloc[filtered_data.index[sorted_indices]][['Brand', 'Model', 'Price', 'Weight', 'Stiffness', 'Balance_Point', 'Image', 'Description']]

        print("\n=== Combined Scores Debugging ===")
        for i in sorted_indices:
            brand_model = f"{original_data.iloc[filtered_data.index[i]]['Brand']} {original_data.iloc[filtered_data.index[i]]['Model']}"
            print(f"{brand_model.ljust(40)}")
            print(f"{'Euclidean Similarity:':<25} {euclidean_similarity[i]:.4f}")
            print(f"{'Cosine Similarity:':<25} {cosine_similarities_flat[i]:.4f}")
            print(f"{'Combined Score:':<25} {combined_scores[i]:.4f}")
            print("================================")
        
    return jsonify({"status": "success", "recommendations": recommendations.to_dict(orient='records')}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)


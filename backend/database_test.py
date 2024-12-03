from supabase import create_client
import json

# URL dan API key Supabase
url = "https://nmawtbiigrkveeovsctu.supabase.co"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5tYXd0YmlpZ3JrdmVlb3ZzY3R1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1ODAwMzAsImV4cCI6MjA0NzE1NjAzMH0.PN20e0p-VEIGvUgK7MZkVZGDDwl3YWDufv-KE8cxVxI"  

# Inisialisasi client Supabase
supabase = create_client(url, key)

response = supabase.table('Rackets_data1').select('Brand', 'Model').execute()
print(json.dumps(response.data, indent=4))
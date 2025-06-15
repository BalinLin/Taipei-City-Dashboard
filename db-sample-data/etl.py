import requests
import time
from typing import List, Tuple, Union, Dict
import json

def geocode_address(address: str, api_key: str) -> Union[Tuple[float, float], None]:
	"""
	Convert an address to latitude and longitude using Google Maps Geocoding API

	Args:
		address: The address to geocode
		api_key: Google Maps API key

	Returns:
		A tuple of (latitude, longitude) or None if geocoding failed
	"""
	base_url = "https://maps.googleapis.com/maps/api/geocode/json"
	params = {
		"address": address,
		"key": api_key
	}

	try:
		response = requests.get(base_url, params=params)
		data = response.json()

		if data["status"] == "OK":
			location = data["results"][0]["geometry"]["location"]
			return location["lat"], location["lng"]
		else:
			print(f"Geocoding failed for address '{address}'. Status: {data['status']}")
			return None
	except Exception as e:
		print(f"Error geocoding address '{address}': {str(e)}")
		return None

def batch_geocode(addresses: List[str], api_key: str, delay: float = 0.1) -> List[Dict[str, Union[str, float, None]]]:
	"""
	Batch geocode a list of addresses

	Args:
		addresses: List of addresses to geocode
		api_key: Google Maps API key
		delay: Delay between API requests in seconds to avoid rate limits

	Returns:
		List of dictionaries with address, latitude and longitude
	"""
	results = []

	for address in addresses:
		location = geocode_address(address, api_key)

		result = {
			"address": address,
			"latitude": None,
			"longitude": None
		}

		if location:
			result["latitude"], result["longitude"] = location

		results.append(result)

		# Add delay to avoid hitting API rate limits
		time.sleep(delay)

	return results

def main():
	# Replace with your Google Maps API key
	api_key = "YOUR_GOOGLE_MAPS_API_KEY"

	# Get input from user
	print("Enter addresses (one per line). Type 'done' on a new line when finished:")

	addresses = []
	while True:
		line = input().strip()
		if line.lower() == 'done':
			break
		if line:  # Skip empty lines
			addresses.append(line)

	if not addresses:
		print("No addresses provided.")
		return

	# Geocode the addresses
	results = batch_geocode(addresses, api_key)

	# Output results
	print("\nGeocoding Results:")
	print("-" * 60)
	for result in results:
		if result["latitude"] is not None and result["longitude"] is not None:
			print(f"Address: {result['address']}")
			print(f"Latitude: {result['latitude']}, Longitude: {result['longitude']}")
			print("-" * 60)
		else:
			print(f"Address: {result['address']}")
			print("Geocoding failed for this address")
			print("-" * 60)

	# Optional: save results to file
	with open("geocoding_results.json", "w") as f:
		json.dump(results, f, indent=2)

	print(f"Results saved to geocoding_results.json")

if __name__ == "__main__":
	main()

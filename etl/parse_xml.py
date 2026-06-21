import xml.etree.ElementTree as ET
import os

def parse_momo_xml(file_path):
    """
    Parses the raw mobile money XML backup file.
    Returns a list of dictionaries containing raw SMS data.
    """
    if not os.path.exists(file_path):
        print(f"Error: XML file not found at {file_path}")
        return []

    try:
        tree = ET.parse(file_path)
        root = tree.getroot()
        
        transactions = []
        
        for sms in root.findall('sms'):
            body = sms.get('body')
            timestamp = sms.get('readable_date')
            source_address = sms.get('address')
            
            record = {
                "source_address": source_address,
                "timestamp": timestamp,
                "raw_message": body
            }
            transactions.append(record)
            
        return transactions
    except Exception as e:
        print(f"Failed to parse XML: {e}")
        return []

if __name__ == "__main__":
    import json
    
    file_target = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'data', 'raw', 'modified_sms_v2.xml')
    parsed_data = parse_momo_xml(file_target)
    
    if parsed_data:
        print(json.dumps(parsed_data[:3], indent=2))
    else:
        print("No data parsed.")

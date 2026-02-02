#parsing the xml data and returning a list of dictonaries

import xml.etree.ElementTree as ET

def parse():
    """
    Parse SMS transaction data from an XML file and categorize transactions.
    
    This function reads 'modified_sms_v2 (1).xml' and extracts SMS transaction data,
    categorizing each message based on keywords found in the message body and returning
    JSON objects (list of dictionaries). 
    
    
    Returns:
        list: A list of dictionaries, where each dictionary contains:
            - 'id' (str): A unique identifier based on transaction type and count
              (e.g., 'Pay1', 'Rec2', 'Ban3', 'Tra4', 'Oth5')
            - 'sms' (dict): The SMS attributes from the XML element
    
    """
    try:
        tree = ET.parse('modified_sms_v2 (1).xml')
        root= tree.getroot()

    except ET.ParseError as e :
        print("error reading the file ", e)
        exit()

    data = []
    count=0

    #a payment person id =Pay
    #a receive id = Rec
    #a bank deposit = Ban
    # a transfer = Tra
    #other = oth


    for child in root:
        count+=1
        body = child.attrib["body"]
        # date= child.attrib['readable_date']

        if "payment" in body:
            id=f"Pay{count}"
        elif "received" in body:
            id=f"Rec{count}"
        elif "bank" in body:
            id=f"Ban{count}"
        elif "transferred" in body:
            id=f"Tra{count}"
        else:
            id=f"Oth{count}" 

        info = {"id":id,"sms":child.attrib}                   
        data.append(info)

    return data
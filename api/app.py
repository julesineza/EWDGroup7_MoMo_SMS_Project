import json
from flask import Flask , request , jsonify
from functools import wraps
import base64
from dsa.parser import parse 
from authentication import require_basic_auth

app = Flask(__name__)

#variable to hold parsed records from the xml file done by the parse function in parser.py
records=parse()

@app.route("/")
def home():
    return "home"

@app.route("/transactions")
@require_basic_auth
def transactions():
    return jsonify(records)

@app.route("/transactions/<id>")
@require_basic_auth
def transaction(id):
    for record in records:
        if record.get("id") == id:
            return jsonify(record)
    return jsonify({"error":"Id not found"}) , 404

@app.route("/transactions/",methods=["POST"])
@require_basic_auth
def add_transaction():
    if request.method == "POST":
        
        data = request.get_json()
        if data is None:
            return jsonify({"error": "Invalid JSON"}), 400
        
        body = data.get("body")
        count = len(records) + 1

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

        to_add = {"id":id,"sms":data}
        records.append(to_add)
        return jsonify(to_add) ,201

@app.route("/transactions/<id>", methods=["PUT"])
@require_basic_auth
def update_record(id):
    data = request.get_json()
    for r in records:
        if r["id"] == id:
            r["sms"].update(data)
            return jsonify(r)
    return jsonify({"error": "Not found"}), 404           

@app.route ("/transactions/<id>",methods =["DELETE"])
@require_basic_auth
def delete():
    if request.method == "DELETE":
        data = request.get_json()
        for record in records:
            if record["id"] == id:
                records.remove(record)
                return jsonify({"success":f"{id} removed successfully"}) , 200
            
        return jsonify({"error":"Id not found"}) , 404   


if __name__ == "__main__":
    app.run(debug=True)
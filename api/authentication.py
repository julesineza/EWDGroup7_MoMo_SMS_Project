from flask import Flask , request , jsonify
from functools import wraps
import base64

#demo password and username
USERNAME = "admin"
PASSWORD="admin123"

#basic auth 
def require_basic_auth(f):
    """
    Decorator that enforces HTTP Basic Authentication on Flask routes.
    
    This decorator validates the Authorization header in incoming requests,
    ensuring that it contains valid Basic Authentication credentials matching
    the predefined USERNAME and PASSWORD constants.
    
    Args:
        f (function): The Flask route function to be decorated
    
    Returns:
        function: The decorated function with authentication enforcement
    
    """
    
    @wraps(f)
    def decorated(*args, **kwargs):
        """
        Inner wrapper function that performs the actual authentication check.
        
        This function intercepts the decorated route, validates the Authorization
        header, and only allows the original route function to execute if
        authentication succeeds.
        
        Args:
            *args: Variable length argument list passed to the decorated function
            **kwargs: Arbitrary keyword arguments passed to the decorated function
        
        Returns:
            tuple or Response: Either:
                - (dict, int): JSON error response with 401 status on auth failure
                - The return value of the original decorated function on success
        
        """

        auth = request.headers.get("Authorization")

        if not auth:
            return jsonify({"error": "Authorization header missing"}), 401

        try:
            # Example: "Basic YWRtaW46cGFzc3dvcmQxMjM="
            scheme, encoded = auth.split(" ")

            if scheme != "Basic":
                return jsonify({"error": "Invalid auth scheme"}), 401

            decoded = base64.b64decode(encoded).decode("utf-8")
            username, password = decoded.split(":")

            if username != USERNAME or password != PASSWORD:
                return jsonify({"error": "Invalid credentials"}), 401

        except Exception:
            return jsonify({"error": "Malformed Authorization header"}), 401

        return f(*args, **kwargs)

    return decorated
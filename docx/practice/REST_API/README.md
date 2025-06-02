# ---------------------- API ------------------------# 
API (Application Programming Interface):
    API is basically a way of communicating two software applications. 
    It acts as a bridge between two software applications to communicate or exchange data.

# ---------------------- REST API ------------------------ #
REST API (Representational State Transfer API):
    REST is a architecture that adds some rules and procedures to the API.
    The API that follows the REST architecture is called RESTful API. 
    It allows to perform 'CRUD' Operations.

    How REST API Work:
        1. Client-Server Architecture
        2. Statelessness
        3. Cacheability
        4. Layered System

Using curl for CRUD:
    1. READ   - "curl http://localhost:port/<resource>" 
    2. CREATE - "curl -X POST http://localhost:port/<resource> -H "Content-Type: application/json(change it accordingly)" -d '{<data>}'"
    3. UPDATE - "curl -X PUT http://localhost:port/<resource> -H "Content-Type: application/json(change it accordingly)" -d '{<data>}'"
    4. DELETE - "curl -X DELETE http://localhost:port/<resource>" 
1. 参考资料

   - <https://blog.ndepend.com/rest-vs-restful/>
  

REST vs. RESTful: The Difference and Why the Difference Doesn’t Matter
What’s the difference between a REST API and a RESTful one? Is there a difference? This sounds like the kind of academic question that belongs on Reddit. But then you find yourself in a design session, and the person across the table is raising their voice.

The short answer is that REST stands for Representational State Transfer. It’s an architectural pattern for creating web services. A RESTful service is one that implements that pattern.

The long answer starts with “sort of” and “it depends” and continues with more complete definitions.


Defining REST
Let’s start by defining what REST is and is not. For some, REST means a server that exchanges JSON documents with a client over HTTP. Not only is that not a complete definition, but it’s also not always true. The REST specification doesn’t require HTTP or JSON. (The spec doesn’t mention JSON or XML at all.)

The Origins of REST
Roy Fielding introduced the REST architectural pattern in a dissertation he wrote in 2000. The paper defines a means for clients and servers to exchange application data. A key feature is that the client doesn’t need to know anything about the application in advance. The link is to chapter five of his paper. While the entire dissertation describes the hows and whys of REST, that chapter defines the architectural pattern.

Fielding doesn’t mandate specific requirements. Instead, he defines REST regarding constraints and architectural elements.

REST’s Architectural Constraints
Here is a summary of the constraints.

Client-server – REST applications have a server that manages application data and state. The server communicates with a client that handles the user interactions. A clear separation of concerns divides the two components. This means you can update and improve them in independent tracks.
Stateless – servers don’t maintain any client state. Clients manage their application state. Their requests to servers contain all the information required to process them.
Cacheable – servers must mark their responses as cacheable or not. So, infrastructures and clients can cache them when possible to improve performance. They can dispose of non-cacheable Information, so no client uses stale data.
Uniform interface – this constraint is REST’s most well known feature or rule, depending on who you ask. Fielding says “The central feature that distinguishes the REST architectural style from other network-based styles is its emphasis on a uniform interface between components.” REST services provide data as resources, with a consistent namespace. We’ll cover this in detail below.
Layered system – components in the system cannot “see” beyond their layer. So, you can easily add load-balancers and proxies to improve security or performance.
A RESTful service is more than a web server that exchanges JSON, or any other, documents. These constraints work together to create a very specific type of application.

Applying the Constraints
First, the client-server, layered systems and stateless constraints combine to form an application with solid boundaries and clear separations between concerns. Data moves from the server to the client upon request. The client displays or manipulates it. If the state changes, the client sends it back to the server for storage. Fielding specifically contrasts REST with architectures that use distributed objects to hide data from other components. In REST, the client and server share knowledge about data and state. The architecture doesn’t conceal data, it only hides implementations.

The cacheable and uniform state constraints go one step further. Application data is available to clients in a clear and consistent interface and cached when possible.

So, that’s the technical definition of REST. What does it look like in the real world?

RPC Over HTTP vs. RESTful
Often when someone says that a service “isn’t REST,” they’re looking at the URIs or how the service uses HTTP verbs. They’re referring to REST’s presentation of data as a uniform set of resources.

This distinction is sometimes framed as a difference between remote procedures calls (RPC) and REST. Imagine a web service for listing, adding, and removing, items from an e-commerce inventory.

In one version, there’s a single URL that we query with HTTP GETs or POSTs.  You interact with the service by POSTing a document, setting the contents to reflect what you want to do.

Add new items with a POST with a NewItem:

POST /inventory HTTP/1.1

{
    "NewItem": {
          "name": "new item",
          "price": "9.99",
          "id": "1001"
      }
}    
1
2
3
4
5
6
7
8
9
POST /inventory HTTP/1.1
 
{
    "NewItem": {
          "name": "new item",
          "price": "9.99",
          "id": "1001"
      }
}    
Query for items with a POST and an ItemRequest:

POST /inventory HTTP/1.1

{
    "ItemRequest": {
          "id": "1001"
      }
}
1
2
3
4
5
6
7
POST /inventory HTTP/1.1
 
{
    "ItemRequest": {
          "id": "1001"
      }
}
Some implementations accept a request for a new item with a get, too.

POST /inventory?id=1001 HTTP/1.1
1
POST /inventory?id=1001 HTTP/1.1
We also change or delete items with a POST and an ItemDelete or ItemUpdate.

POST /inventory HTTP/1.1

{
    "ItemDelete": {
          "id": "1001"
      }
}
1
2
3
4
5
6
7
POST /inventory HTTP/1.1
 
{
    "ItemDelete": {
          "id": "1001"
      }
}
This isn’t REST. We’re not exchanging the state of resources. We’re calling a function with arguments that happen to be in a JSON document or URL arguments.

A RESTful service has a URI for each item in the inventory.

So, adding a new item would look like the example above.

POST /item HTTP/1.1

{
    "Item": {
          "name": "new item",
          "price": "9.99",
          "id": "1001"
      }
}    
1
2
3
4
5
6
7
8
9
POST /item HTTP/1.1
 
{
    "Item": {
          "name": "new item",
          "price": "9.99",
          "id": "1001"
      }
}    
But the similarities end there. Retrieving an item is always a GET:

GET /item/1001 HTTP/1.1    
1
GET /item/1001 HTTP/1.1    
Deleting is a DELETE:

DELETE /item/1001 HTTP/1.1    
1
DELETE /item/1001 HTTP/1.1    
Modifying an item is a PUT:

POST /inventory HTTP/1.1

{
    "Item": {
          "name": "new item",
          "price": "7.99",
          "id": "1001"
      }
}    
1
2
3
4
5
6
7
8
9
POST /inventory HTTP/1.1
 
{
    "Item": {
          "name": "new item",
          "price": "7.99",
          "id": "1001"
      }
}    
The difference is important. In REST, operations that use distinct HTTP actions. These verbs correspond directly to the activity on the data. GET, POST, PUT, DELETE and PATCH all have specific contracts. Most well-designed REST APIs also return specific HTTP codes, depending on the result of the request.

The critical point is that the URIs operate on the data, not on remote methods.

But there’s another reason why the resource model is essential.

REST vs RESTful and the Richardson Maturity Model
When you model your URIs after resources and use HTTP verbs you make your API predictable. Once developers know how you defined your resources, they can almost predict what the API looks like. Here again, the emphasis is on understanding the data, not the operations.

But even if you can’t make the API entirely predictable, you can document any REST service with hypertext. So, each item returned in the inventory app would contain links for deleting, modifying, or setting the inventory level of the resource. Fielding says that before a service is RESTful, it must provide hypertext media as part of the API.

Many sites don’t meet this requirement but are still called REST. Fact is, many sites break the rules in one way or another. So many that Leonard Richardson created a model breaks down REST into levels of compliance.

We’ve already covered the source levels:

0 – exporting an API over HTTP with methods called with arguments
1 – Exporting resources instead of methods
2 – Proper use of HTTP verbs
3 – Exporting hypertext with objects that make all or part of the API discoverable.
Richardson’s model is his own, and it doesn’t map directly into Fielding’s spec. Since Fielding requires level three, he would say that most apps aren’t REST anyway.

The point is many services that we colloquially refer to as REST, technically aren’t.

REST vs RESTful: Does It Matter?
So, does the REST vs. RESTful comparison matter? Probably not. How well your architecture complies with an arbitrary standard isn’t as important with how well it suits your needs and can grow with your business.

The REST architectural pattern has many advantages. Fielding designed it for the web and, 18 years later, most of the constraints he had in mind are still with us. In 2000 we didn’t have Android or the iPhone. IE5 had 50% of the browser market share. It’s biggest rival was Firefox. But Fielding recognized what online applications needed and how web clients would evolve from HTML display engines into complete applications. The tools we use today have grown to suit REST, not the other way around.

Richardson’s maturity model is a good guideline for designing your applications. You want to be at level two of the model, and looking at how level three might make your design better.
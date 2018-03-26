# Companny information REST API

##### By Jakob Warrer Thygsen

https://tehwarrer-api.herokuapp.com/

#### Features

* MongoDB using mongoid
* Versioning using Sinatra Namespace
* Searchable with basic partial matching

GET all companies
https://tehwarrer-api.herokuapp.com/api/v1/companies

```sh
[
    {
        "id": "5ab7ba4bbf0df30004ce2cb4",
        "cvr": 5234123123,
        "company_name": "Boring Company",
        "address": "Boring Address",
        "city": "Boring City",
        "country": "Boring Country",
        "phone_number": 12345678
    },
    {
        "id": "5ab7ba7ebf0df30004ce2cb6",
        "cvr": 543234234,
        "company_name": "Awesome Company",
        "address": "Awesome Company",
        "city": "Awesome Company",
        "country": "Awesome Company",
        "phone_number": 87654321
    }
]
```

GET company by specific ID
https://tehwarrer-api.herokuapp.com/api/v1/companies/5ab7ba4bbf0df30004ce2cb4

```sh
{
    "id": "5ab7ba4bbf0df30004ce2cb4",
    "cvr": 5234123123,
    "company_name": "Boring Company",
    "address": "Boring Address",
    "city": "Boring City",
    "country": "Boring Country",
    "phone_number": 12345678
}
```

GET 404 error if company ID doesn't exist
https://tehwarrer-api.herokuapp.com/api/v1/companies/5ab7ba4bbf0df30004ce2cb2

```sh
{
    "message": "Company Not Found"
}
```

GET with search parameters, with some basic partial matching
https://tehwarrer-api.herokuapp.com/api/v1/companies?company_name=Boring

```sh
[
    {
        "id": "5ab7ba4bbf0df30004ce2cb4",
        "cvr": 5234123123,
        "company_name": "Boring Company",
        "address": "Boring Address",
        "city": "Boring City",
        "country": "Boring Country",
        "phone_number": 12345678
    }
]
```

POST new company

```sh
curl -i -X POST -H "Content-Type: application/json" -d'{"cvr":"9321983129", "company_name":"Exciting Company", "address":"Exciting Road", "city":"Exciting City", "country":"Exciting Country", "phone_number","45362718"}' https://tehwarrer-api.herokuapp.com/api/v1/companies
```

PATCH edit existing company

```sh
curl -i -X PATCH -H "Content-Type: application/json" -d '{"company_name":"Not Boring at all Company"}' https://tehwarrer-api.herokuapp.com/api/v1/companies/5ab7ba4bbf0df30004ce2cb4
```

DELETE company

```sh
curl -i -X DELETE -H "Content-Type: application/json" https://tehwarrer-api.herokuapp.com/api/v1/companies/5ab7ba4bbf0df30004ce2cb4
```

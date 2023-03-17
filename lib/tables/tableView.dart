import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template/appBar.dart';
import 'package:flutter_template/tiles/tilesWidget.dart';
import 'package:collection/collection.dart';

class TableView extends StatefulWidget {
  const TableView({super.key, required this.tile});
  final tile;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  bool fetching = true;

  List<String> columns = [];

  var tableJSON = {
    "\$schema":
        "http://docs.oasis-open.org/odata/odata-json-csdl/v4.0/edm.json#",
    "odata-version": "4.0",
    "definitions": {
      "ODataDemo.Products": {
        "type": "object",
        "mediaEntity": true,
        "keys": ["ID"],
        "properties": {
          "ID": {"type": "string"},
          "Description": {
            "type": ["string", "null"],
            "@Core.IsLanguageDependent": true
          },
          "ReleaseDate": {
            "type": ["string", "null"],
            "format": "date"
          },
          "DiscontinuedDate": {
            "type": ["string", "null"],
            "format": "date"
          },
          "Rating": {
            "type": ["integer", "null"],
            "format": "int32"
          },
          "Price": {
            "type": ["number", "string", "null"],
            "format": "decimal",
            "multipleOf": 1,
            "@Org.OData.Measures.V1.ISOCurrency": {"@odata.path": "Currency"}
          },
          "Currency": {
            "type": ["string", "null"],
            "maxLength": 3
          },
          "Category": {
            "anyOf": [
              {"\$ref": "#/definitions/ODataDemo.Category"}
            ],
            "relationship": {"partner": "Products"}
          },
          "Supplier": {
            "anyOf": [
              {"\$ref": "#/definitions/ODataDemo.Supplier"},
              {"type": "null"}
            ],
            "relationship": {"partner": "Products"}
          }
        }
      },
      "ODataDemo.Category": {
        "type": "object",
        "keys": ["ID"],
        "properties": {
          "ID": {"type": "integer", "format": "int32"},
          "Name": {"type": "string", "@Core.IsLanguageDependent": true},
          "Products": {
            "type": "array",
            "items": {"\$ref": "#/definitions/ODataDemo.Product"},
            "relationship": {
              "partner": "Category",
              "onDelete": {"action": "Cascade"}
            }
          }
        }
      },
      "ODataDemo.Supplier": {
        "type": "object",
        "keys": ["ID"],
        "properties": {
          "ID": {"type": "string"},
          "Name": {
            "type": ["string", "null"]
          },
          "Address": {"\$ref": "#/definitions/ODataDemo.Address"},
          "Concurrency": {"type": "integer", "format": "int32"},
          "Products": {
            "type": "array",
            "items": {"\$ref": "#/definitions/ODataDemo.Product"},
            "relationship": {"partner": "Supplier"}
          }
        }
      },
      "ODataDemo.Country": {
        "type": "object",
        "keys": ["Code"],
        "properties": {
          "Code": {"type": "string", "maxLength": 2},
          "Name": {
            "type": ["string", "null"]
          }
        }
      },
      "ODataDemo.Address": {
        "type": "object",
        "properties": {
          "Street": {
            "type": ["string", "null"]
          },
          "City": {
            "type": ["string", "null"]
          },
          "State": {
            "type": ["string", "null"]
          },
          "ZipCode": {
            "type": ["string", "null"]
          },
          "CountryName": {
            "type": ["string", "null"]
          },
          "Country": {
            "anyOf": [
              {"\$ref": "#/definitions/ODataDemo.Country"},
              {"type": "null"}
            ],
            "relationship": {
              "referentialConstraints": {
                "CountryName": {"referencedProperty": "Name"}
              }
            }
          }
        }
      }
    },
    "schemas": {
      "Org.OData.Core.V1": {
        "\$ref":
            "http://docs.oasis-open.org/odata/odata/v4.0/Org.OData.Core.V1.json#/schemas/Org.OData.Core.V1"
      },
      "Core": {
        "\$ref":
            "http://docs.oasis-open.org/odata/odata/v4.0/Org.OData.Core.V1.json#/schemas/Org.OData.Core.V1"
      },
      "Org.OData.Measures.V1": {
        "\$ref":
            "http://docs.oasis-open.org/odata/odata/v4.0/Org.OData.Measures.V1.json#/schemas/Org.OData.Measures.V1"
      },
      "UoM": {
        "\$ref":
            "http://docs.oasis-open.org/odata/odata/v4.0/Org.OData.Measures.V1.json#/schemas/Org.OData.Measures.V1"
      },
      "ODataDemo": {}
    },
    "functions": {
      "ODataDemo.ProductsByRating": [
        {
          "parameters": [
            {
              "name": "Rating",
              "parameterType": {
                "type": ["integer", "null"],
                "format": "int32"
              }
            }
          ],
          "returnType": {
            "type": "array",
            "items": {"\$ref": "#/definitions/ODataDemo.Product"}
          }
        }
      ]
    },
    "entityContainer": {
      "name": "DemoService",
      "entitySets": {
        "Products": {
          "entityType": {"\$ref": "#/definitions/ODataDemo.Product"},
          "navigationPropertyBindings": {
            "Category": {"target": "Categories"}
          }
        },
        "Categories": {
          "entityType": {"\$ref": "#/definitions/ODataDemo.Category"},
          "navigationPropertyBindings": {
            "Products": {"target": "Products"}
          }
        },
        "Suppliers": {
          "entityType": {"\$ref": "#/definitions/ODataDemo.Supplier"},
          "navigationPropertyBindings": {
            "Products": {"target": "Products"},
            "Address/Country": {"target": "Countries"}
          },
          "@Core.OptimisticConcurrency": [
            {"@odata.propertyPath": "Concurrency"}
          ]
        },
        "Countries": {
          "entityType": {"\$ref": "#/definitions/ODataDemo.Country"}
        }
      },
      "singletons": {
        "Contoso": {
          "type": {"\$ref": "#/definitions/ODataDemo.Supplier"},
          "navigationPropertyBindings": {
            "Products": {"target": "Products"}
          }
        }
      },
      "functionImports": {
        "ProductsByRating": {
          "entitySet": "Products",
          "function": {"\$ref": "#/functions/ODataDemo.ProductsByRating"}
        }
      }
    }
  };

  @override
  void initState() {
    super.initState();
    getMetadata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarIcon(actions: []),
        backgroundColor: Theme.of(context).backgroundColor,
        body: fetching
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(columns: [
                    for (var column in columns)
                      DataColumn(
                        label: Text(column),
                      )
                  ], rows: []),
                )));
  }

  void getMetadata() {
    var objects = tableJSON["definitions"] as Map<String, dynamic>;
    objects.forEach((key, value) {
      if (key.endsWith(".${widget.tile["name"]}")) {
        value["properties"].forEach((key, value) {
          columns.add(key);
        });
      }
    });

    fetching = false;
  }
}

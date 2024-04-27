/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  // remove
  collection.schema.removeField("kivvsvvy")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "yeyrsj0b",
    "name": "to",
    "type": "text",
    "required": true,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "kivvsvvy",
    "name": "to",
    "type": "email",
    "required": true,
    "presentable": false,
    "unique": false,
    "options": {
      "exceptDomains": [],
      "onlyDomains": []
    }
  }))

  // remove
  collection.schema.removeField("yeyrsj0b")

  return dao.saveCollection(collection)
})

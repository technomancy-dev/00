/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  // remove
  collection.schema.removeField("2gd4pkek")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "gjnljksn",
    "name": "from",
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
    "id": "2gd4pkek",
    "name": "from",
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
  collection.schema.removeField("gjnljksn")

  return dao.saveCollection(collection)
})

/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "apokisul",
    "name": "aws_message_id",
    "type": "text",
    "required": false,
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

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "apokisul",
    "name": "aws_message_id",
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
})

/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_riRdQi4` ON `emails` (`aws_message_id`)",
    "CREATE UNIQUE INDEX `idx_Oy3JCQG` ON `emails` (`email_id`)"
  ]

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "f5dltuoe",
    "name": "email_id",
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

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_riRdQi4` ON `emails` (`aws_message_id`)"
  ]

  // remove
  collection.schema.removeField("f5dltuoe")

  return dao.saveCollection(collection)
})

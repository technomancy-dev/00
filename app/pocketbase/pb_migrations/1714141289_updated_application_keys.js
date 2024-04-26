/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("b1nn9xsiaprwvhp")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_VHDatUZ` ON `application_keys` (`key_id`)"
  ]

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "i1tfmymj",
    "name": "key_id",
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

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "vwtklapz",
    "name": "key_hash",
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
  const collection = dao.findCollectionByNameOrId("b1nn9xsiaprwvhp")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_kvtD7YJ` ON `application_keys` (`key`)"
  ]

  // remove
  collection.schema.removeField("i1tfmymj")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "vwtklapz",
    "name": "key",
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

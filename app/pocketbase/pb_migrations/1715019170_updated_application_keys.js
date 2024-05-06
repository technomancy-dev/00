/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("b1nn9xsiaprwvhp")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_VHDatUZ` ON `application_keys` (`key_id`)",
    "CREATE UNIQUE INDEX `idx_moml8tC` ON `application_keys` (`user`)",
    "CREATE INDEX `idx_HZ2zilF` ON `application_keys` (`aws_account_id`)"
  ]

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "rrkmiaky",
    "name": "aws_account_id",
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
  const collection = dao.findCollectionByNameOrId("b1nn9xsiaprwvhp")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_VHDatUZ` ON `application_keys` (`key_id`)",
    "CREATE UNIQUE INDEX `idx_moml8tC` ON `application_keys` (`user`)"
  ]

  // remove
  collection.schema.removeField("rrkmiaky")

  return dao.saveCollection(collection)
})

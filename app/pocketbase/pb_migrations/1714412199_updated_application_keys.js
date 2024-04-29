/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("b1nn9xsiaprwvhp")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_VHDatUZ` ON `application_keys` (`key_id`)",
    "CREATE UNIQUE INDEX `idx_moml8tC` ON `application_keys` (`user`)"
  ]

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("b1nn9xsiaprwvhp")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_VHDatUZ` ON `application_keys` (`key_id`)"
  ]

  return dao.saveCollection(collection)
})

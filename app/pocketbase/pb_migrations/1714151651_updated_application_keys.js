/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("b1nn9xsiaprwvhp")

  collection.listRule = ""

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("b1nn9xsiaprwvhp")

  collection.listRule = "user = @request.auth.id || key_id = @request.query.key_id"

  return dao.saveCollection(collection)
})

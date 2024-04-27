/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  collection.name = "emails"
  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_riRdQi4` ON `emails` (`aws_message_id`)"
  ]

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  collection.name = "Emails"
  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_riRdQi4` ON `Emails` (`aws_message_id`)"
  ]

  return dao.saveCollection(collection)
})

/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  collection.indexes = [
    "CREATE INDEX `idx_riRdQi4` ON `emails` (`aws_message_id`)",
    "CREATE UNIQUE INDEX `idx_Oy3JCQG` ON `emails` (`email_id`)"
  ]

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_riRdQi4` ON `emails` (`aws_message_id`)",
    "CREATE UNIQUE INDEX `idx_Oy3JCQG` ON `emails` (`email_id`)"
  ]

  return dao.saveCollection(collection)
})

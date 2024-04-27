/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "szwc204qbmot4sv",
    "created": "2024-04-26 22:07:49.531Z",
    "updated": "2024-04-26 22:07:49.531Z",
    "name": "Emails",
    "type": "base",
    "system": false,
    "schema": [
      {
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
      },
      {
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
      },
      {
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
      },
      {
        "system": false,
        "id": "ct6o4ymi",
        "name": "sent_by",
        "type": "relation",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "_pb_users_auth_",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": null
        }
      }
    ],
    "indexes": [
      "CREATE UNIQUE INDEX `idx_riRdQi4` ON `Emails` (`aws_message_id`)"
    ],
    "listRule": "@request.auth.id = sent_by.id",
    "viewRule": "@request.auth.id = sent_by.id",
    "createRule": "@request.auth.id = sent_by.id",
    "updateRule": "@request.auth.id = sent_by.id",
    "deleteRule": "@request.auth.id = sent_by.id",
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("szwc204qbmot4sv");

  return dao.deleteCollection(collection);
})

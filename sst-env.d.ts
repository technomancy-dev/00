/* tslint:disable */
/* eslint-disable */
import "sst"
declare module "sst" {
  export interface Resource {
    ZeroEmailSNS: {
      arn: string
      type: "sst.aws.SnsTopic"
    }
    ZeroEmailSQS: {
      type: "sst.aws.Queue"
      url: string
    }
    ZeroEmailService: {
      type: "sst.aws.Service"
      url: string
    }
    ZeroSQLiteBucket: {
      name: string
      type: "sst.aws.Bucket"
    }
  }
}
export {}
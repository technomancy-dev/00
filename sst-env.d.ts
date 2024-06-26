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
  }
}
export {}
/// <reference path="./.sst/platform/config.d.ts" />

export default $config({
  app(input) {
    return {
      name: "double-zero",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
    };
  },
  async run() {
    const topic = new sst.aws.SnsTopic("ZeroEmailSNS");
    const queue = new sst.aws.Queue("ZeroEmailSQS");
    topic.subscribeQueue(queue.arn);

    const configSet = new aws.sesv2.ConfigurationSet("ZeroEmailConfigSet", {
      configurationSetName: "zero_email_events",
    });

    const exampleConfigurationSetEventDestination =
      new aws.sesv2.ConfigurationSetEventDestination("ZeroEmailEvent", {
        configurationSetName: configSet.configurationSetName,
        eventDestinationName: "zero_email_sns",
        eventDestination: {
          snsDestination: {
            topicArn: topic.arn,
          },
          enabled: true,
          matchingEventTypes: ["SEND"],
        },
      });
    const exampleEmailIdentity = new aws.sesv2.EmailIdentity("ZeroEmail", {
      emailIdentity: "fidoforms.com",
      configurationSetName: configSet.configurationSetName,
    });
  },
});

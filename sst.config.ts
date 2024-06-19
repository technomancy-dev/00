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
    if (!process.env.EMAIL_IDENTITY) {
      const message = "Need to set EMAIL_IDENTITY env variable.";
      console.error(message);
      throw Error(message);
    }
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
          matchingEventTypes: [
            "SEND",
            "REJECT",
            "BOUNCE",
            "COMPLAINT",
            "DELIVERY",
            // TODO: Handle all these.
            // "OPEN",
            // "CLICK",
            // "RENDERING_FAILURE",
            // "DELIVERY_DELAY",
            // "SUBSCRIPTION",
          ],
        },
      });

    const exampleEmailIdentity = new aws.sesv2.EmailIdentity("ZeroEmail", {
      emailIdentity: process.env.EMAIL_IDENTITY || "",
      configurationSetName: configSet.configurationSetName,
    });

    return { queue: queue.url };
  },
});

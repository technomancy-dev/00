// @ts-nocheck
/** @jsxImportSource react */
import React from "react";

import { Section } from "jsx-email";

export const Template = ({ html }) => {
  return (
    <Section lang="en" dir="ltr" dangerouslySetInnerHTML={{ __html: html }} />
  );
};

export default Template;

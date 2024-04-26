/** @jsxImportSource react */
import { createRoute } from "honox/factory";

import { render } from "jsx-email";
import Template from "../emails/WelcomeEmail";

export default createRoute(async (c) => {
  const html = await render(<Template />);
  return c.html(html);
});

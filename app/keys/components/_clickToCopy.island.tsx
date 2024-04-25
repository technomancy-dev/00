import { useState } from "hono/jsx";

import { CopyOutline } from "./CopyIcon";

const ClickToCopy = ({ children, clipboard }) => {
  const [copied, setCopied] = useState(false);
  const copy = () => {
    navigator.clipboard.writeText(clipboard);
    setCopied(true);
    setTimeout(() => setCopied(false), 1000);
  };
  return (
    <div>
      <div className="flex items-center gap-2 justify-between" onClick={copy}>
        {copied ? "Copied!" : children}
        <CopyOutline />
      </div>
    </div>
  );
};

export default ClickToCopy;

import React, { useEffect, useState } from "react";
import AccessibleButton from "./components/AccessibleButton";

export default function App() {
  const [apps, setApps] = useState([]);

  useEffect(() => {
    fetch("/api/apps/")
      .then((r) => r.json())
      .then(setApps)
      .catch(console.error);
  }, []);

  return (
    <div className="app-root">
      <h1>Launcher Accessibility (PoC)</h1>
      <div className="apps-grid">
        {apps.map((a) => (
          <AccessibleButton key={a.id} label={a.name} onClick={() => alert(`Acció: ${a.action}`)} />
        ))}
      </div>
    </div>
  );
}

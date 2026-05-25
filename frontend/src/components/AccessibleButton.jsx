import React from "react";
import "../styles.css";

export default function AccessibleButton({ label, onClick, ariaLabel }) {
  const speak = (text) => {
    if (typeof window !== "undefined" && 'speechSynthesis' in window) {
      const msg = new SpeechSynthesisUtterance(text);
      window.speechSynthesis.cancel();
      window.speechSynthesis.speak(msg);
    }
  };

  const handleClick = (e) => {
    speak(label);
    if (onClick) onClick(e);
  };

  return (
    <button
      className="accessible-button"
      onClick={handleClick}
      aria-label={ariaLabel || label}
    >
      {label}
    </button>
  );
}

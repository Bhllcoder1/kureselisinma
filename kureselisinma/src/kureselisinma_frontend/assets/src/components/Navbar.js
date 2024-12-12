import React from 'react';
import { Link } from 'react-router-dom';

function Navbar() {
  return (
    <nav>
      <div className="logo">Anonim Yardımlaşma Merkezi</div>
      <ul>
        <li><Link to="/">Ana Sayfa</Link></li>
        <li><Link to="/about">Hakkımızda</Link></li>
        <li><Link to="/campaigns">Bağış Kampanyaları</Link></li>
        <li><Link to="/contact">İletişim</Link></li>
      </ul>
    </nav>
  );
}

export default Navbar;
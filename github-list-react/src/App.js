/*
 * @Description: 应用的主要组件，包含路由设置和整体布局
 */
import React from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import HomePage from './components/HomePage';
import UserDetailsPage from './components/UserDetailsPage';
import './styles/App.css';

function App() {
  return (
    <div className="App">
      <Router>
        {/* 导航栏 */}
        <nav className="nav">
          <ul>
            <li><Link to="/">首页</Link></li>
            <li><Link to="/user/example">用户详情</Link></li>
          </ul>
        </nav>
        {/* 主要内容区域 */}
        <div className="content">
          <Routes>
            <Route exact path="/" element={<HomePage />} />
            <Route path="/user/:username" element={<UserDetailsPage />} />
          </Routes>
        </div>
      </Router>
    </div>
  );
}

export default App;

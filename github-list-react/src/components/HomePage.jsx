/*
 * @Description: 主页组件，显示用户列表和搜索功能
 */
import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import UserList from './UserList';
import SearchBar from './SearchBar';

function HomePage() {
  // 状态管理
  const [users, setUsers] = useState([]); // 用户列表
  const [searchTerm, setSearchTerm] = useState(''); // 搜索关键词
  const [page, setPage] = useState(1); // 当前页码
  const [loading, setLoading] = useState(false); // 加载状态

  // 当搜索关键词或页码变化时，重新获取用户数据
  useEffect(() => {
    fetchUsers();
  }, [searchTerm, page]);

  // 获取用户数据的异步函数
  const fetchUsers = async () => {
    setLoading(true);
    try {
      const response = await fetch(`https://api.github.com/search/users?q=${searchTerm || 'a'}&page=${page}`);
      const data = await response.json();
      // 如果是第一页，直接设置数据；否则，追加数据
      setUsers(prevUsers => page === 1 ? data.items : [...prevUsers, ...data.items]);
    } catch (error) {
      console.error('Error fetching users:', error);
    }
    setLoading(false);
  };

  // 处理搜索操作
  const handleSearch = (term) => {
    setSearchTerm(term);
    setPage(1); // 重置页码
  };

  // 处理刷新操作
  const handleRefresh = () => {
    setPage(1);
    fetchUsers();
  };

  // 处理加载更多操作
  const handleLoadMore = () => {
    setPage(prevPage => prevPage + 1);
  };

  return (
    <div>
      <SearchBar onSearch={handleSearch} />
      <UserList 
        users={users} 
        onRefresh={handleRefresh}
        onLoadMore={handleLoadMore}
        loading={loading}
      />
    </div>
  );
}

export default HomePage;
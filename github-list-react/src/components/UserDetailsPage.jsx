/*
 * @Description: 用户详情页组件，显示用户详细信息和仓库列表
 */
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import UserItem from './UserItem';
import RepositoryList from './RepositoryList';

function UserDetailsPage() {
  const { username } = useParams(); // 获取 URL 中的用户名参数
  const [user, setUser] = useState(null);
  const [repositories, setRepositories] = useState([]);
  const [loading, setLoading] = useState(true);

  // 当用户名变化时，重新获取用户详情和仓库列表
  useEffect(() => {
    fetchUserDetails();
    fetchUserRepositories();
  }, [username]);

  // 获取用户详细信息
  const fetchUserDetails = async () => {
    try {
      const response = await fetch(`https://api.github.com/users/${username}`);
      const data = await response.json();
      setUser(data);
    } catch (error) {
      console.error('Error fetching user details:', error);
    }
  };

  // 获取用户仓库列表
  const fetchUserRepositories = async () => {
    try {
      const response = await fetch(`https://api.github.com/users/${username}/repos`);
      const data = await response.json();
      setRepositories(data);
    } catch (error) {
      console.error('Error fetching user repositories:', error);
    }
    setLoading(false);
  };

  if (loading) return <div>加载中...</div>;

  return (
    <div>
      {user && <UserItem user={user} />}
      <RepositoryList repositories={repositories} />
    </div>
  );
}

export default UserDetailsPage;
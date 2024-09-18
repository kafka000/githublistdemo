/*
 * @Description: 用户列表组件，显示搜索结果
 */
import React from 'react';
import { Link } from 'react-router-dom';
import UserItem from './UserItem';

function UserList({ users, onRefresh, onLoadMore }) {
  return (
    <div>
      {users.map(user => (
        <Link to={`/user/${user.login}`} key={user.id}>
          <UserItem user={user} />
        </Link>
      ))}
      {/* 这里可以添加下拉刷新和上拉加载更多的逻辑 */}
    </div>
  );
}

export default UserList;
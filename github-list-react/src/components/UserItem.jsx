/*
 * @Description: 用户项组件，显示单个用户的信息
 */
import React, { useState } from 'react';

function UserItem({ user }) {
  const [isFollowed, setIsFollowed] = useState(false);

  const handleFollow = (e) => {
    e.preventDefault(); // 防止链接跳转
    setIsFollowed(!isFollowed);
  };

  return (
    <div>
      <img src={user.avatar_url} alt={user.login} />
      <div>
        <div>
          {user.login.length > 20 ? `${user.login.substring(0, 20)}...` : user.login} 
          <span>{user.score}</span>
        </div>
        <div>{user.html_url}</div>
      </div>
      <button onClick={handleFollow}>
        {isFollowed ? 'FOLLOWED' : 'FOLLOW'}
      </button>
    </div>
  );
}

export default UserItem;
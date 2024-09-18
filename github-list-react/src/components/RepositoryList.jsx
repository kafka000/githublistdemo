/*
 * @Description: 仓库列表组件，显示用户的仓库信息
 */
import React from 'react';

function RepositoryList({ repositories }) {
  return (
    <div>
      <h2>仓库列表</h2>
      {repositories.map(repo => (
        <div key={repo.id}>
          <h3>{repo.name}</h3>
          <p>{repo.description}</p>
          <p>星标数: {repo.stargazers_count}</p>
          <a href={repo.html_url} target="_blank" rel="noopener noreferrer">查看仓库</a>
        </div>
      ))}
    </div>
  );
}

export default RepositoryList;
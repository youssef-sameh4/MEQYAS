using MEQYAS.Application.Abstractions.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Infrastructure.Repositories
{
    public class GenericRepository<T> : IGenericRepository<T>
 where T : class
    {
        protected readonly DbContext _context;
        protected readonly DbSet<T> _dbSet;

        public GenericRepository(DbContext context)
        {
            _context = context;
            _dbSet = context.Set<T>();
        }

        public async Task<T?> GetByIdAsync(
            Guid id,
            CancellationToken cancellationToken = default)
        {
            return await _dbSet.FindAsync(
                new object[] { id },
                cancellationToken);
        }

        public IQueryable<T> GetTableNoTracking()
        {
            return _dbSet.AsNoTracking();
        }

        public IQueryable<T> GetTableAsTracking()
        {
            return _dbSet.AsTracking();
        }

        public async Task<T> AddAsync(
            T entity,
            CancellationToken cancellationToken = default)
        {
            await _dbSet.AddAsync(entity, cancellationToken);
            return entity;
        }

        public async Task AddRangeAsync(
            ICollection<T> entities,
            CancellationToken cancellationToken = default)
        {
            await _dbSet.AddRangeAsync(entities, cancellationToken);
        }

        public void Update(T entity)
        {
            _dbSet.Update(entity);
        }

        public void UpdateRange(ICollection<T> entities)
        {
            _dbSet.UpdateRange(entities);
        }

        public void Delete(T entity)
        {
            _dbSet.Remove(entity);
        }

        public void DeleteRange(ICollection<T> entities)
        {
            _dbSet.RemoveRange(entities);
        }

    }
}

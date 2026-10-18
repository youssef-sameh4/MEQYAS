using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Abstractions.Interfaces
{
    public interface IGenericRepository<T> where T : class
    {
        Task<T?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);

        IQueryable<T> GetTableNoTracking();

        IQueryable<T> GetTableAsTracking();

        Task<T> AddAsync(
            T entity,
            CancellationToken cancellationToken = default);

        Task AddRangeAsync(
            ICollection<T> entities,
            CancellationToken cancellationToken = default);

        void Update(T entity);

        void UpdateRange(ICollection<T> entities);

        void Delete(T entity);

        void DeleteRange(ICollection<T> entities);
    }
}

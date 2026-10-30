using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Bases
{
    using System.Net;

    namespace MEQYAS.Application.Bases
    {
        public class ResponseHandler
        {
            public ResponseHandler()
            {
            }

            public Response<T> Success<T>(T entity, object? meta = null)
            {
                return new Response<T>
                {
                    Data = entity,
                    StatusCode = HttpStatusCode.OK,
                    Succeeded = true,
                    Message = "Success",
                    Meta = meta
                };
            }

            public Response<T> Created<T>(T entity, object? meta = null)
            {
                return new Response<T>
                {
                    Data = entity,
                    StatusCode = HttpStatusCode.Created,
                    Succeeded = true,
                    Message = "Created Successfully",
                    Meta = meta
                };
            }

            public Response<T> BadRequest<T>(string? message = null)
            {
                return new Response<T>
                {
                    StatusCode = HttpStatusCode.BadRequest,
                    Succeeded = false,
                    Message = message ?? "Bad Request"
                };
            }

            public Response<T> NotFound<T>(string? message = null)
            {
                return new Response<T>
                {
                    StatusCode = HttpStatusCode.NotFound,
                    Succeeded = false,
                    Message = message ?? "Not Found"
                };
            }

            public Response<T> Unauthorized<T>()
            {
                return new Response<T>
                {
                    StatusCode = HttpStatusCode.Unauthorized,
                    Succeeded = false,
                    Message = "Unauthorized"
                };
            }

            public Response<T> Deleted<T>(string ?message=null)
            {
                return new Response<T>
                {
                    StatusCode = HttpStatusCode.OK,
                    Succeeded = true,
                    Message = message ?? "Deleted Successfully"
                };
            }
        }
    }
}

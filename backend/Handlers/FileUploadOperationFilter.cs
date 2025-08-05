using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace ErzurumAkilliSehirAPI.Handlers
{
    public class FileUploadOperationFilter : IOperationFilter
    {
        public void Apply(OpenApiOperation operation, OperationFilterContext context)
        {
            var fileParameters = context.ApiDescription.ParameterDescriptions
                .Where(x => x.ModelMetadata?.ModelType == typeof(IFormFile) ||
                           x.ModelMetadata?.ModelType?.GetProperties()?.Any(p => p.PropertyType == typeof(IFormFile)) == true);

            foreach (var parameter in fileParameters)
            {
                var content = new Dictionary<string, OpenApiMediaType>
                {
                    {
                        "multipart/form-data", new OpenApiMediaType
                        {
                            Schema = new OpenApiSchema
                            {
                                Type = "object",
                                Properties = new Dictionary<string, OpenApiSchema>
                                {
                                    {
                                        "Image", new OpenApiSchema
                                        {
                                            Type = "string",
                                            Format = "binary"
                                        }
                                    }
                                }
                            }
                        }
                    }
                };

                operation.RequestBody = new OpenApiRequestBody
                {
                    Content = content
                };
            }
        }
    }
}
using ErzurumAkilliSehirAPI.Models;
using FluentValidation;

namespace ErzurumAkilliSehirAPI.Validator
{
    public class ProjectValidator : AbstractValidator<Project>
    {
        public ProjectValidator()
        {
            RuleFor(p => p.Title).NotEmpty().MaximumLength(100);
            RuleFor(p => p.Description).NotEmpty();
            RuleFor(p => p.ImageUrl).Must(uri => Uri.TryCreate(uri, UriKind.Absolute, out _))
                .When(p => !string.IsNullOrEmpty(p.ImageUrl));
        }
    }
}

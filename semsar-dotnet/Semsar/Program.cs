using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Semsar.Data;
using Semsar.Hubs;
using Semsar.Models.chat;
using Semsar.Models.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSignalR();

builder.Services.AddResponseCompression(options =>
    options.MimeTypes = ResponseCompressionDefaults.
    MimeTypes.
    Concat(new[] { "application/octet-stream" })
    );

var handler = new HttpClientHandler
{
    ServerCertificateCustomValidationCallback = (HttpRequestMessage, X509Certificate2, X509Chain, SslPolicyErrors) => true
};

var client = new HttpClient(handler);


builder.Services.AddCors(options =>
{
    options.AddPolicy("CorsPolicy", builder =>
    {
        builder.WithOrigins("http://localhost:5554") // Replace with your Flutter app's URL
               .AllowAnyHeader()
               .AllowAnyMethod()
               .AllowCredentials();
    });
});


builder.Services.AddSwaggerGen(opt =>
{
    opt.SwaggerDoc("v1", new OpenApiInfo { Title = "MyAPI", Version = "v1" });
    opt.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please enter token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "bearer"
    });

    opt.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type=ReferenceType.SecurityScheme,
                    Id="Bearer"
                }
            },
            new string[]{}
        }
    });
});


builder.Services.AddDbContext<DataContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")
        );
});


builder.Services.AddAuthorization();

builder.Services.AddIdentityApiEndpoints<IdentityUser>()
    .AddEntityFrameworkStores<DataContext>();

builder.Services.AddScoped<HousesServices>();
builder.Services.AddScoped<UserServices>();
builder.Services.AddSingleton<SharedDb>();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();


app.UseAuthorization();

app.MapControllers();

app.MapIdentityApi<IdentityUser>();

app.UseResponseCompression();

app.MapHub<Chats>("/chatHub");

app.UseCors("CorsPolicy");


app.Run();

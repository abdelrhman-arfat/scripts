<?php

namespace App\Console\Commands;

use Illuminate\Console\GeneratorCommand;
use Illuminate\Support\Str;

class MakeService extends GeneratorCommand
{
    protected $name = 'make:service';
    protected $description = 'Create a new HTTP Service and Interface';
    protected $type = 'Service';

    /**
     * Default namespace for Services
     */
    protected function getDefaultNamespace($rootNamespace)
    {
        return $rootNamespace . '\Http\Services';
    }

    protected function getStub()
    {
        return '';
    }


    /**
     * Handle the command
     */
    public function handle()
    {
        $name = $this->argument('name');

        // إزالة أي suffix Service
        $baseName = Str::replaceLast('Service', '', $name);

        $interfaceName = $baseName . 'Interface';
        $serviceName = $baseName . 'Service';

        // إنشاء Interface
        $this->createInterface($baseName);

        // إنشاء Service
        $this->createService($baseName);

        // تسجيل bind في ServiceProvider
        $this->registerInServiceProvider($baseName, $serviceName);
        $bindLine = "\$this->app->bind(\\App\\Http\\Contracts\\{$baseName}Interface::class, \\App\\Http\\Services\\{$serviceName}::class);";
        $this->line($bindLine);
        $this->info("Service & Interface created successfully.");
    }

    /**
     * Create the Interface
     */
    protected function createInterface($baseName)
    {
        $interfaceDir = app_path('Http/Contracts');

        if (!is_dir($interfaceDir)) {
            mkdir($interfaceDir, 0755, true);
        }

        $interfacePath = $interfaceDir . '/' . $baseName . 'Interface.php';

        if (!file_exists($interfacePath)) {
            $interfaceContent = <<<PHP
<?php

namespace App\Http\Contracts;

interface {$baseName}Interface
{
    //
}
PHP;

            file_put_contents($interfacePath, $interfaceContent);
            $this->info("Interface created: Http/Contracts/{$baseName}Interface.php");
        } else {
            $this->info("Interface already exists: Http/Contracts/{$baseName}Interface.php");
        }
    }

    /**
     * Create the Service
     */
    protected function createService($baseName)
    {
        $serviceDir = app_path('Http/Services');

        if (!is_dir($serviceDir)) {
            mkdir($serviceDir, 0755, true);
        }

        $servicePath = $serviceDir . '/' . $baseName . 'Service.php';

        if (!file_exists($servicePath)) {
            $serviceContent = <<<PHP
<?php

namespace App\Http\Services;

use App\Http\Contracts\\{$baseName}Interface;

class {$baseName}Service implements {$baseName}Interface
{
    //
}
PHP;

            file_put_contents($servicePath, $serviceContent);
            $this->info("Service created: Http/Services/{$baseName}Service.php");
        } else {
            $this->info("Service already exists: Http/Services/{$baseName}Service.php");
        }
    }

    /**
     * Register the Service bind in AppServiceProvider
     */
    protected function registerInServiceProvider($baseName, $serviceName)
    {
        $providerPath = app_path('Providers/AppServiceProvider.php');
        $content = file_get_contents($providerPath);

        $bindCode = "        \$this->app->bind(\\App\\Http\\Contracts\\{$baseName}Interface::class, \\App\\Http\\Services\\{$serviceName}::class);";

        if (!str_contains($content, $bindCode)) {
            // أضف bind داخل دالة register
            $content = preg_replace(
                '/public function register\(\)\s*\{/',
                "public function register()\n    {\n{$bindCode}",
                $content,
                1
            );

            file_put_contents($providerPath, $content);
            $this->info("Service bound in AppServiceProvider");
        } else {
            $this->info("Service already bound in AppServiceProvider");
        }
    }
}

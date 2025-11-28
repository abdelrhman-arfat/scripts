<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Str;

class MakeService extends Command
{
    protected $signature = 'make:service
                            {name : The service name}
                            {--model : Generate a database repository service}';

    protected $description = 'Create a Domain Service or Repository Service with Interface';

    public function handle()
    {
        $name = $this->argument('name');
        $isModel = $this->option('model');

        // إزالة أي suffix Service
        $baseName = Str::replaceLast('Service', '', $name);

        $serviceName = $baseName . 'Service';
        $interfaceName = $baseName . 'Interface';

        // اختيار المجلدات حسب الخيار
        if ($isModel) {
            $rootFolder = 'Repositories';
            $namespaceRoot = 'App\\Repositories';
        } else {
            $rootFolder = 'Domain';
            $namespaceRoot = 'App\\Domain';
        }

        // المجلدات الفرعية
        $interfaceDir = app_path("{$rootFolder}/Interfaces");
        $serviceDir   = app_path("{$rootFolder}/Services");

        // إنشاء المجلدات إذا لم توجد
        if (!is_dir($interfaceDir)) mkdir($interfaceDir, 0755, true);
        if (!is_dir($serviceDir)) mkdir($serviceDir, 0755, true);

        // إنشاء Interface
        $this->createInterface($interfaceDir, $namespaceRoot . '\\Interfaces', $baseName);

        // إنشاء Service
        $this->createService($serviceDir, $namespaceRoot . '\\Services', $namespaceRoot . '\\Interfaces', $baseName);

        // طباعة bind جاهز للنسخ
        $bindLine = "\$this->app->bind(\\{$namespaceRoot}\\Interfaces\\{$interfaceName}::class, \\{$namespaceRoot}\\Services\\{$serviceName}::class);";
        $this->line($bindLine);

        $this->info("Service & Interface created successfully.");
    }

    protected function createInterface($dir, $namespace, $baseName)
    {
        $interfacePath = $dir . '/' . $baseName . 'Interface.php';

        if (!file_exists($interfacePath)) {
            $interfaceContent = <<<PHP
<?php

namespace {$namespace};

interface {$baseName}Interface
{
    //
}
PHP;
            file_put_contents($interfacePath, $interfaceContent);
            $this->info("Interface created: {$interfacePath}");
        } else {
            $this->info("Interface already exists: {$interfacePath}");
        }
    }

    protected function createService($dir, $namespace, $interfaceNamespace, $baseName)
    {
        $servicePath = $dir . '/' . $baseName . 'Service.php';

        if (!file_exists($servicePath)) {
            $serviceContent = <<<PHP
<?php

namespace {$namespace};

use {$interfaceNamespace}\\{$baseName}Interface;

class {$baseName}Service implements {$baseName}Interface
{
    //
}
PHP;
            file_put_contents($servicePath, $serviceContent);
            $this->info("Service created: {$servicePath}");
        } else {
            $this->info("Service already exists: {$servicePath}");
        }
    }
}

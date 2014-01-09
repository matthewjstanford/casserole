class Chef
  class Recipe
    def jvm_heap_size_mb
      mem = system_memory_mb

      if (mem * 0.25).to_i > 8196 # not more than 8GB
        heap = 8196
      elsif mem.to_i < 2048 # Less than 2GB 1/2 of system memory
        heap = (mem * 0.5).to_i
      elsif mem.to_i >= 2048 && mem.to_i <= 4096 # 2GB to 4GB 1GB
        heap = 1024
      else # 25% of memory 
        heap = (mem * 0.25).to_i
      end
      return heap
    end

    def system_memory_mb
      # Obtain the system memory and set the knotice configuration
      system_memory = node['memory']['total']
      # Ohai reports node[:memory][:total] in kB, as in "921756kB"
      mem = system_memory.split("kB")[0].to_i / 1024 # in MB
      return mem
    end

    def key_cache_size_mb
      # min(5% of Heap (in MB), 100MB)
      cache = jvm_heap_size_mb * 0.05

      if cache > 100
        return cache
      else
        return 100
      end
    end
  end
end

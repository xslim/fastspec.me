Fastspec
========================

### Recreating image versions
* `Feature.all.each {|f| f.image.recreate_versions! if f.image?}`
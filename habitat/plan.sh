pkg_name=phila-gov
pkg_origin=timwis
pkg_version="0.1.0"
pkg_maintainer="City of Philadelphia <oddt@phila.gov>"
pkg_license=("GPL-2.0")
# pkg_source="http://some_source_url/releases/${pkg_name}-${pkg_version}.tar.gz"
# pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
# pkg_shasum="TODO"
pkg_deps=(core/wordpress/4.7.4)
pkg_build_deps=(core/aws-cli timwis/wp-cli)
# pkg_lib_dirs=(lib)
# pkg_include_dirs=(include)
# pkg_bin_dirs=(bin)
# pkg_pconfig_dirs=(lib/pconfig)
# pkg_svc_run="haproxy -f $pkg_svc_config_path/haproxy.conf"
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )
# pkg_exposes=(port ssl-port)
pkg_binds=(
  [database]="port host username password"
)
# pkg_binds_optional=(
#   [storage]="port host"
# )
# pkg_interpreters=(bin/bash)
# pkg_svc_user="hab"
# pkg_svc_group="$pkg_svc_user"
# pkg_description="Some description."
# pkg_upstream_url="http://example.com/project-name"

do_build() {
  # attach
  local plugins_bucket="phila-wp-plugins-timwistest"

  local plugins="mb-admin-columns-1.3.0.zip
  mb-revision-1.1.1.zip
  meta-box-columns-1.2.3.zip
  meta-box-conditional-logic-1.5.5.zip
  meta-box-group-1.2.13.zip
  meta-box-include-exclude-1.0.9.zip
  meta-box-tabs-1.0.3.zip
  meta-box-tooltip-1.1.1.zip
  wpfront-user-role-editor-personal-pro-2.14.1.zip"

  for plugin in $plugins; do
    echo "Installing $plugin"
    s3_url="s3://$plugins_bucket/$plugin"
    presigned_s3_url=$(aws s3 presign "$s3_url" --expires-in 600)
    wp plugin install --force --activate --allow-root "$presigned_s3_url"
  done
}

do_install() {
  local source_dir=$HAB_CACHE_SRC_PATH/${pkg_name}
  cp -r "$source_dir"/wp "$pkg_prefix/public_html/"
}

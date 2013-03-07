package Schema::Result::Users;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "user_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "username",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->has_many(assets => 'Schema::Result::Door', 'user_id');

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2012-09-16 16:25:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IWFi6e28xXic2rkOq3Aafg


# You can replace this text with custom content, and it will be preserved on regeneration
1;

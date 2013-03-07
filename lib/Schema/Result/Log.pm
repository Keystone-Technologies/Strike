package Schema::Result::Log;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("log");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "dt",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "user_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "message",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2012-09-16 16:25:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Yj23S13DNnou4Tksm7WHNw


# You can replace this text with custom content, and it will be preserved on regeneration
1;

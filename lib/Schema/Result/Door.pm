package Schema::Result::Door;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("door");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "user_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "acl",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 4 },
  "badge",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "sn",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "pin",
  { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(user => 'Schema::Result::Users', 'user_id', {join_type=>'left'});


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2012-09-16 16:25:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ly4cCYqoxG3YQGhPBsbgpA


# You can replace this text with custom content, and it will be preserved on regeneration
1;

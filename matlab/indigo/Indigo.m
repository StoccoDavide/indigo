function obj = Indigo( name )
  eval( sprintf( 'obj = Indigo_%s();',name ) );
end

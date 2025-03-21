import '../entities/role_entity.dart';

abstract class RoleRepository {
  Future<List<RoleEntity>> initialize();
  Future<void> addRole(RoleEntity role);
  Future<List<RoleEntity>> getAllRoles();
  Future<RoleEntity?> getRoleById(String id);
  Future<void> updateRole(RoleEntity role);
  Future<void> deleteRole(String id);
  Future<List<RoleEntity>> searchRolesByName(String query);
}

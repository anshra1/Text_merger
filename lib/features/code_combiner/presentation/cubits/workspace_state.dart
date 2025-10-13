import 'package:equatable/equatable.dart';
import 'package:text_merger/core/error/failure.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';
import 'package:text_merger/features/code_combiner/domain/repositories/code_combiner_repository.dart';

sealed class WorkspaceState extends Equatable {
  const WorkspaceState();
}

abstract class WorkspaceStateWithWorkspaces extends WorkspaceState {
  const WorkspaceStateWithWorkspaces(this.workspaces);

  final List<RecentWorkspace> workspaces;

  @override
  List<Object> get props => [workspaces];
}

class WorkspaceInitial extends WorkspaceState {
  const WorkspaceInitial();

  @override
  List<Object> get props => [];
}

class WorkspaceLoading extends WorkspaceStateWithWorkspaces {
  const WorkspaceLoading(super.workspaces);
}

class WorkspaceError extends WorkspaceState {
  const WorkspaceError(this.failure);

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class SuccessState extends WorkspaceState {
  const SuccessState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class WorkspaceLoaded extends WorkspaceStateWithWorkspaces {
  const WorkspaceLoaded(super.workspaces);
}

class WorkspaceOpened extends WorkspaceState {
  const WorkspaceOpened(this.workspaceData);

  final WorkspaceData workspaceData;

  @override
  List<Object> get props => [workspaceData];
}

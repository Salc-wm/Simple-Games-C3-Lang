module gofl_rylib;

import std::io;

struct Simulation
{
    bool run;
    int cells_live;

    Grid grid;
}

const ichar[<2>][8] NEIGHBORS_OFFSETS @local =
{
    {-1, 0 },
    { 1, 0 },
    { 0,-1 },
    { 0, 1 },
    {-1,-1 },
    {-1, 1 },
    { 1,-1 },
    { 1, 1 }
};


fn int Simulation.getValue(Simulation* self, Table grid) @inline =>
    self.isWithinBounds(grid) ?
        self.grid.getValue(grid):0;

fn bool Simulation.isWithinBounds(Simulation* self, Table grid) @local @inline =>
    grid.x >= 0 && grid.x < self.grid.rows && grid.y >= 0 && grid.y < self.grid.columns ? true : false;

fn int Simulation.countLiveNeighbors(Simulation* self, Table grid) @local {
    int live_neighbors = 0;

    foreach (offset: NEIGHBORS_OFFSETS) {
        int neighbors_row = (grid.x + offset.x + self.grid.getRows()) % self.grid.getRows();
        int neighbors_column = (grid.y + offset.y + self.grid.getColumns()) % self.grid.getColumns();

        live_neighbors += self.getValue({neighbors_row, neighbors_column});
    }

    return live_neighbors;
}

macro void Simulation.draw(Simulation* self) => self.grid.draw();
macro void Simulation.clearGrid(Simulation* self) => self.grid.clear();

fn void Simulation.toggleCell(Simulation* self, Table grid, char v) @local {
    if (!self.@isRunning() && self.isWithinBounds(grid)) self.grid.toggleCell(grid, v);
}

fn void Simulation.hoverCell(Simulation* self, Table grid) @local {
    if (self.@isRunning() && !self.isWithinBounds(grid)) return;

    if (self.getValue(grid) != 1) self.grid.hoverCell(grid);
}

fn void Simulation.actionCell(Simulation* self, Table mouse, bool action, char v) {
    if (action) {
        self.toggleCell(mouse, v);
        return;
    }

    self.hoverCell(mouse);
}

macro int Simulation.getLivingCells(Simulation* self) => self.cells_live;

macro void Simulation.stop(Simulation* self) => self.run = false;
macro void Simulation.start(Simulation* self) => self.run = true;

macro bool Simulation.@isRunning(Simulation* &self) => self.run;
macro void Simulation.createRandomState(Simulation* self) => self.grid.fillRandom();

fn void Simulation.update(Simulation* self) {
    if (!self.@isRunning()) return;

    Grid temp_grid = self.grid;

    foreach (int idxr, row: self.grid.cells) foreach (int idxc, _n: row) {
        Table pos = { idxr, idxc };

        int live_neighbors = self.countLiveNeighbors(pos);
        int cell_value = self.getValue(pos);

        if (cell_value) {
            if (live_neighbors > 3 || live_neighbors < 2) {
                temp_grid.setValue(pos, 0);
                continue;
            }

            self.grid.setLivingCells();
            temp_grid.setValue(pos, 1);

            continue;
        }

        if (live_neighbors == 3) {
            self.grid.setLivingCells();
            temp_grid.setValue(pos, 1);

            continue;
        }

        temp_grid.setValue(pos, 0);
    }

    self.cells_live = self.grid.l_cells;
    self.grid = temp_grid;
}
